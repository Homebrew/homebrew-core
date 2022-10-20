class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.16.0.tar.gz"
  sha256 "035f3508ad3954aa1117f662f9f59541e7a0059483b15d573a8146d997b54827"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f88f7470a3ab319df911d8633e2b0fd461cfa1443ddb4f1b4b120bf1e33e21ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02ec3dacab7389f07c8129fb51aa7010f129f47a1487a3f2cb2d310fc9180b23"
    sha256 cellar: :any_skip_relocation, monterey:       "6915a9e9b28aecd9e851ece1d2167b91c46b4381e42aa9474e4648a20b3ca6a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "21995063ea04551b5614214b126a8478557ddd1899fdd1e288d6742aca90bfe5"
    sha256 cellar: :any_skip_relocation, catalina:       "adc1647af84503351c0d631cf1dc21027222c9934083f78b9d6a2a6254a66e59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad1e5690fbbc0ac71bff4dadb50ab5451eafbc5ee4bce1a4da2145436040ad1"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
