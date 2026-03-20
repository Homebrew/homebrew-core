class Secretspec < Formula
  desc "Declarative secrets management tool"
  homepage "https://secretspec.dev"
  url "https://github.com/cachix/secretspec/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "bb93d9897f80592e249ea14b65bb2b3703c3cc97006c0497ef899681566f2181"
  license "Apache-2.0"
  head "https://github.com/cachix/secretspec.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "971b57133919468a2c2b7c1cc60a342bfaf9f728b486cd8f5246e503da136262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c1098450fce56543a74dd20a542e18197eab8ca4085e2c258337b65c5ad8fe8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cec6fcc98a8810b7c0d3c76fe944cbf0b61cda114a09e4c126f3413710a0689"
    sha256 cellar: :any_skip_relocation, sonoma:        "c0b55bdc6211ba63fec47c81951440e16ebeb7c90e2734cc5ba08bd08debbbb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5e4c1704e68f06a7d75ede413736e1d04cc996ce80c8af847692dd6a599ded8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aefc6c87ee8d275078812f42aa1cba414e4e783a0ed292f850b2117da752bf28"
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
