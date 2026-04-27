import 'package:mc_client/main.dart';
import 'package:test/test.dart';

void main() {
  test('renders fleet node status', () {
    const node = FleetNode(name: 'wsl1', status: 'healthy');
    expect(renderFleetNode(node), 'wsl1:healthy');
  });
}
