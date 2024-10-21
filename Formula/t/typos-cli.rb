class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "d546fdc8d0caea03a54b962b079a7634171c857bfde469520a5abb740514ac11"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5e548cb44f60ae2346979f86f35bb09331cbbc76b6fa1101d968da45c3e1db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "679c3f4b53d064b38aa992b22c0f3b53fc20211e62eb89925625ad248916ad20"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "171ea847d1361acd0b184c777b0188de523100262499798dbf0945e93ff9ad29"
    sha256 cellar: :any_skip_relocation, sonoma:        "2be7133324181f6d75afe85d4234c24150f73144d0c9b3c30a0d79172c6bf942"
    sha256 cellar: :any_skip_relocation, ventura:       "3dd6d2e065c34ea04498b117e61f53cc75d7ef5e0defaae28cf96b9750558a9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1072cc9228b90f6fb7c472631535f92d37bfe3cf11f3015c5bf0ecec5975a83c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
