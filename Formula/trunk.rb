class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.8.0.tar.gz"
  sha256 "5c5c320a42e4446292eb5f0843da86e5fa2d798b904801ce28c8295b678a83e5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "37b5d7e5469b41fb586f996eb6f4ab94863a2780f986d4cd27b9c7f295078704"
    sha256 cellar: :any_skip_relocation, big_sur:       "f3377776db1fd33651b9500ac625bfec0ea806c8a509d48605064a6d9ff1b64f"
    sha256 cellar: :any_skip_relocation, catalina:      "ad77113d27d6c35a3a161423993e5d49ebf70ff5989b7691bd9559945c27791b"
    sha256 cellar: :any_skip_relocation, mojave:        "f6e2954c9f2befbac069a567276168d8c17706fd5676e1deb3b89c829eed8de1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
