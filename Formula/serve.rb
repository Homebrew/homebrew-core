class Serve < Formula
    desc "A static http server anywhere you need one"
    homepage "https://github.com/syntaqx/serve"
    url "https://github.com/syntaqx/serve/releases/download/v0.2.0/serve_0.2.0_macos_x86_64.tar.gz"
    version "0.2.0"
    sha256 "95951376c655c512578de440a2f455cfb1b3a8fc20dc34ac6e9474eba87846ba"

    def install
      bin.install "serve"
    end

    test do
      system "#{bin}/serve", "  version"
    end
  end
