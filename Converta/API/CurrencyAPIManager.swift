//
//  CurrencyAPIManager.swift
//  Converta
//
//  Created by Ernest Dainals on 15/02/2023.
//

import Foundation

final class CurrencyAPIManager {
    static let shared = CurrencyAPIManager()
    
    private init() {}
    
    private let api_key = "mfO4cZYMAvNnyN2BI4VHYxsBgTKhxrhu4pFlKb1A"
    private let baseURl = "https://api.currencyapi.com/v3/"
    
    private func getLatestCurrencyURL(baseCurrency: String, currencies: String?) -> String {
        if currencies == nil {
            return baseURl + "latest?apikey=\(api_key)&base_currency=\(baseCurrency)"
        } else {
            return baseURl + "latest?apikey=\(api_key)&base_currency=\(baseCurrency)&currencies=\(currencies!)"
        }
    }
    
    private func getCurrenciesURL() -> String {
        return baseURl + "currencies?apikey=\(api_key)"
    }
    
    private func getHistoricalURL(date: Date, baseCurrency: CurrencyCode) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedDate = dateFormatter.string(from: date)
        
        return baseURl + "historical?apikey=\(api_key)&date=\(formattedDate)&base_currency=\(baseCurrency.rawValue)"
    }
    
    func getLatestCurrencyData(baseCurrency: CurrencyCode, currencies: String? = nil, completed: @escaping (Result<CurrencyAPIResponse_Latest, APIError>) -> Void) {
        guard let url = URL(string: getLatestCurrencyURL(baseCurrency: baseCurrency.rawValue, currencies: currencies)) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(CurrencyAPIResponse_Latest.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getAvailableCurrencies(completed: @escaping (Result<CurrencyAPIResponse_Currencies, APIError>) -> Void) {
        guard let url = URL(string: getCurrenciesURL()) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(CurrencyAPIResponse_Currencies.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getHistoricalCurrencyData(date: Date, baseCurrency: CurrencyCode, completed: @escaping (Result<CurrencyAPIResponse_Historical, APIError>) -> Void) {
        guard let url = URL(string: getHistoricalURL(date: date, baseCurrency: baseCurrency)) else {
            completed(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let decodedResponse = try decoder.decode(CurrencyAPIResponse_Historical.self, from: data)
                completed(.success(decodedResponse))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error { case invalidURL, invalidResponse, invalidData, unableToComplete }
