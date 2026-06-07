import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/api_constants.dart';
import '../models/pokemon_list_item.dart';
import '../models/pokemon_detail.dart';

/// Custom exception for API-related errors
class PokemonApiException implements Exception {
  final String message;
  PokemonApiException(this.message);
  
  @override
  String toString() => 'PokemonApiException: $message';
}

/// Repository handling all PokéAPI HTTP calls
class PokemonRepository {
  final http.Client _client;

  PokemonRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetches a list of Pokémon with their basic information
  /// [limit] - Number of Pokémon to fetch (default 151)
  /// [offset] - Starting index for pagination
  Future<List<PokemonListItem>> fetchPokemonList({
    int limit = ApiConstants.defaultPokemonLimit,
    int offset = 0,
  }) async {
    try {
      // First, get the list of Pokémon names and URLs
      final listResponse = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}?limit=$limit&offset=$offset'))
          .timeout(ApiConstants.requestTimeout);

      if (listResponse.statusCode != 200) {
        throw PokemonApiException('Failed to fetch Pokémon list: ${listResponse.statusCode}');
      }

      final listData = json.decode(listResponse.body) as Map<String, dynamic>;
      final results = listData['results'] as List<dynamic>;

      // Extract IDs and build detail URLs
      final detailUrls = results.map((r) {
        final id = ApiConstants.extractIdFromUrl(r['url'] as String);
        return Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$id');
      }).toList();

      // Fetch all details in parallel
      final detailResponses = await Future.wait(
        detailUrls.map((url) => _client.get(url).timeout(ApiConstants.requestTimeout)),
      );

      // Parse all responses into PokemonListItem objects
      final pokemonList = <PokemonListItem>[];
      for (final response in detailResponses) {
        if (response.statusCode == 200) {
          final detailData = json.decode(response.body) as Map<String, dynamic>;
          pokemonList.add(PokemonListItem.fromJson(detailData));
        }
      }

      return pokemonList;
    } on TimeoutException {
      throw PokemonApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is PokemonApiException) rethrow;
      throw PokemonApiException('Failed to fetch Pokémon: $e');
    }
  }

  /// Fetches detailed information for a specific Pokémon
  Future<PokemonDetail> fetchPokemonDetail(int id) async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}/$id'))
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw PokemonApiException('Failed to fetch Pokémon detail: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      return PokemonDetail.fromJson(data);
    } on TimeoutException {
      throw PokemonApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is PokemonApiException) rethrow;
      throw PokemonApiException('Failed to fetch Pokémon detail: $e');
    }
  }

  /// Fetches all Pokémon names (up to 898) for the game's wrong answer options
  Future<List<String>> fetchAllPokemonNames() async {
    try {
      final response = await _client
          .get(Uri.parse('${ApiConstants.baseUrl}${ApiConstants.pokemonEndpoint}?limit=${ApiConstants.allPokemonLimit}&offset=0'))
          .timeout(ApiConstants.requestTimeout);

      if (response.statusCode != 200) {
        throw PokemonApiException('Failed to fetch all Pokémon names: ${response.statusCode}');
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;
      
      return results
          .map((r) => (r['name'] as String).toLowerCase())
          .toList();
    } on TimeoutException {
      throw PokemonApiException('Request timed out. Please check your connection.');
    } catch (e) {
      if (e is PokemonApiException) rethrow;
      throw PokemonApiException('Failed to fetch all Pokémon names: $e');
    }
  }

  /// Cleanup method to close the HTTP client
  void dispose() {
    _client.close();
  }
}