class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.9.2.tar.gz"
  sha256 "4a3b0d108a96c49b2c3a8ca0aabfbdc23dc0d7562bcd43410c2ba0834cdc07ed"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24db3fd46fbb03bc070b865b79e76255877455fc67307d783de8bb200183373f"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d603900f9afc9bd6c87cf1b6f519eeb6be6066863f3424b0abc6e71fe371c16"
    sha256 cellar: :any_skip_relocation, catalina:      "2886066c26f57f26a201ad68311f1b87984e1a6443ff8a925a189e3a4142d81c"
    sha256 cellar: :any_skip_relocation, mojave:        "c5a7e7e2fd81d2fc5448c96311f9ed3b0c9b42543f9dc6ac114e8b0c81a61bcf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
