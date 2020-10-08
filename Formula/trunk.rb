class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.7.0.tar.gz"
  sha256 "917cd328a7c2a38ad35c1f3366d581f9c94078a5e9d84ebeb8999408a2b95062"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e30a89f19b89e892613e044bc11b7297c4a4e319cacb5f9738dc26a0f4f6c9a7" => :catalina
    sha256 "4d60c3565e55e1b72914f32a9a7fd546da25e852ba9fe1fadbcecd9c1b58c313" => :mojave
    sha256 "1951420ea7503d12523b1497deea5655737c7b1b95ca0b70696fec6457b715df" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
