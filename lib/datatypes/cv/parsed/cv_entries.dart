import 'cv_match.dart';

/// This datatype is supposed to hold result from parsing json like this:
/// {
///   "Skills": [
///     {"match": "C++", "sentence": "I love C++"},
///     {"match": "Java", "sentence": "I had an experience in Java"}
///   ],
///   "Language": [
///     {"match": "Eng", "sentence": "B2 english"}
///   ]
/// }
typedef CVEntries = Map<String, List<CVMatch>>;
