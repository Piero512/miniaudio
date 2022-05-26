const _kDefaultAssertMessage = 'This instance is already finalized';

void runtimeAssert(bool expression, [String message = _kDefaultAssertMessage]) {
  if (!expression) {
    throw StateError(message);
  }
}
