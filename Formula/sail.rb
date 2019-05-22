class Sail < Formula
  desc "The universal standard for instant, pre-configured dev environments"
  homepage "https://sail.dev"
  url "https://github.com/cdr/sail/archive/v1.0.1.tar.gz"
  sha256 "1fb1fe562894365ac9bd224a1e5ca781bfdb34917afe13af21ee8d526434dc5c"
  depends_on "go" => :build

  def install
    system "go", "build", "-o", "bin/sail", "."
    bin.install "bin/sail" => "sail"
  end

  def caveats; <<~EOS
    You will need docker to use sail.
    Please install via:

      brew cask install docker
  EOS
  end

  test do
    output = `#{bin}/sail --help 2>&1`
    output.include? "A utility for managing Docker-based code-server environments."
  end
end
