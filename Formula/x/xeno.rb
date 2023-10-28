class Xeno < Formula
  desc "xeno is a CLI tool designed for the Xeno-Canto"
  homepage "https://github.com/siansiansu/go-xeno"
  version "1.0.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/siansiansu/go-xeno/releases/download/v1.0.0/go-xeno_Darwin_arm64.tar.gz"
      sha256 "1859f42be8361ce2397fa85091a30763c43753774929a1dd5d1466335d306cc1"

      def install
        bin.install "xeno"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/siansiansu/go-xeno/releases/download/v1.0.0/go-xeno_Darwin_x86_64.tar.gz"
      sha256 "dc01b4c6ebf0e6936148b89c2647e1718d9e4f9344435bc29690ca1e1d4b639d"

      def install
        bin.install "xeno"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/siansiansu/go-xeno/releases/download/v1.0.0/go-xeno_Linux_arm64.tar.gz"
      sha256 "f2f19b51a2ad5a1c023b1d240b58524d6ad5c3568cb1a17b72a7eae3cf8e4014"

      def install
        bin.install "xeno"
      end
    end
    if Hardware::CPU.intel?
      url "https://github.com/siansiansu/go-xeno/releases/download/v1.0.0/go-xeno_Linux_x86_64.tar.gz"
      sha256 "ee255e5900f0ce2fc39ced1180e47e28e9bf02989d6cc080aeeb2f71ae4d883b"

      def install
        bin.install "xeno"
      end
    end
  end

  test do
    system "#{bin}/xeno --help"
  end
end
