class Termbg < Formula
  desc "Rust library for terminal background color detection"
  homepage "https://github.com/dalance/termbg"
  url "https://github.com/dalance/termbg/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "b933907d181e59ce0aa522ed598a9fa70125a6523f7fbd1f537c3b99bd75ffdd"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dalance/termbg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0966ba2c3c68175f179c88b293c396a89867b38aeb1293200527aa66039dfda5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73367dc16651ae85eddfc43526501a01ea3721d3c1d40de0e7dcff2f49f0ea90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "280098ca00d9d2e31672b8bc0cabca6082200c12c936e2c68122ab8b8e79afd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "375b6b6bf7872f951fa94361662929b418326b2680a1c5d03bb54b9319b72fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "185c02be7e39375a0b96aaa18443010547bfab80b7afa1856b6c85db29bcb39e"
    sha256 cellar: :any_skip_relocation, ventura:       "0977f7809818025cd59757e9a4bea7cbd80b81cccf9d3644667e441271f5e786"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb326e7812e6470aeb2da3737d385f02106bd8cf5b36f4d4abfd41c3d0a4f692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98b27a88db545fce6ca91fa68de4370a715636f9313a000dc99a6e9188f8cb84"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termbg --version")
  end
end
