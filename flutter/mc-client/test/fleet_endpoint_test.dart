import 'package:mc_client/main.dart';
import 'package:test/test.dart';

void main() {
  group('FleetEndpointResolver', () {
    test('resolves preferred transport', () {
      final resolver = FleetEndpointResolver(
        tailscale: {
          'wsl1': FleetEndpoint(
            transport: FleetTransport.tailscale,
            uri: Uri.parse('http://wsl1.foo.ts.net:9302'),
            node: 'wsl1',
          ),
        },
        ociJump: {
          'wsl1': FleetEndpoint(
            transport: FleetTransport.ociJump,
            uri: Uri.parse('http://localhost:19302'),
            node: 'wsl1',
          ),
        },
      );
      final ep = resolver.resolve('wsl1');
      expect(ep, isNotNull);
      expect(ep!.transport, FleetTransport.tailscale);
      expect(ep.uri.toString(), 'http://wsl1.foo.ts.net:9302');
    });

    test('falls back to alternate when preferred missing', () {
      final resolver = FleetEndpointResolver(
        tailscale: const {},
        ociJump: {
          'win1': FleetEndpoint(
            transport: FleetTransport.ociJump,
            uri: Uri.parse('http://localhost:19401'),
            node: 'win1',
          ),
        },
      );
      final ep = resolver.resolve('win1');
      expect(ep, isNotNull);
      expect(ep!.transport, FleetTransport.ociJump);
    });

    test('returns null for unknown node', () {
      final resolver = FleetEndpointResolver(
        tailscale: const {},
        ociJump: const {},
      );
      expect(resolver.resolve('ghost'), isNull);
    });

    test('healthCheck path overrides input path', () {
      final ep = FleetEndpoint(
        transport: FleetTransport.tailscale,
        uri: Uri.parse('http://wsl1.foo.ts.net:9302/v1'),
        node: 'wsl1',
      );
      expect(ep.healthCheck.path, '/healthz');
      expect(ep.command.path, '/command');
    });

    test('fromJson decodes preferred + maps', () {
      final resolver = FleetEndpointResolver.fromJson({
        'preferred': 'oci_jump',
        'tailscale': {'wsl1': 'http://wsl1.foo.ts.net:9302'},
        'oci_jump': {'wsl1': 'http://localhost:19302'},
      });
      expect(resolver.preferred, FleetTransport.ociJump);
      final ep = resolver.resolve('wsl1');
      expect(ep!.transport, FleetTransport.ociJump);
    });
  });
}
