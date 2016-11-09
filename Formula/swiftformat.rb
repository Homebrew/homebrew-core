class Swiftformat < Formula
    desc "Formatting tool for Swift source code"
    homepage "https://github.com/nicklockwood/SwiftFormat"
    url "https://github.com/nicklockwood/SwiftFormat/archive/0.17.tar.gz"
    sha256 "68cfc0f783ca331a1fda1c8b5c5a670b6c42be72a44a34b519d61d308b2fe8ea"

    def install
        bin.install "CommandLineTool/swiftformat"
    end

    test do
        system "#{bin}/swiftformat"
    end
end
