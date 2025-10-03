class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "03b61a39b834a459e97540bbf935a57af31fe9d8024b40ad135823fbded61c5d"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "308b775c028405ece38ad1b91591ae6517d77b0f2ddb6f3bceafbb3941472d1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d7d9ea7fc927d112fa79296ca97cfab7e6b21abb2efb3686723f180de492e4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24dc84cb790765cbef406f35995ed5c180627ef52bce1c55a14927fdd04d2f2a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f426d5af0e170d890c12dec15c98e0e2840639df0a9ea7f58fc19da933a5d81b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d972936414ffa1269c4570fa25cef3cd22f0a6b0aa5a4a8e2ff8858ba75276c9"
    sha256 cellar: :any_skip_relocation, ventura:       "049391fb7eaa008ccfa4ca68c6f026347ef2499694609b796a0e230134ab9449"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "715e84f13e1dd31a3f44cd4e2c6f3defbf0a263134c2e9a0e65a8b9eda80a534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d30247a95b61fc15f93106e3afca1e71db1c31542d088ecaab579cd1bf7c6d1c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "secretspec")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/secretspec --version")
    system bin/"secretspec", "init"
    assert_path_exists testpath/"secretspec.toml"
  end
end
