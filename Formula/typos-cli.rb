class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.14.8.tar.gz"
  sha256 "a0a8036c764da5eabf416a457c13940addb8686409594a54906d81c4a90f3926"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a41911a2444d30a7a31a9f6b1ac9b335f40677104d828cd03e7a862203337f47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c7ba8feee92144ddc130b293fe47d85adb50ed48f0ab9034c2917ae95baf446"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e902048368b3714c72a67e35d56db87777f8dd1de58b94a3cb80beae5a8c760a"
    sha256 cellar: :any_skip_relocation, ventura:        "817bcfd7043244cde9caf4da580d1047154f52bbf9a52b01d9f83aa7af9c7c0d"
    sha256 cellar: :any_skip_relocation, monterey:       "b327729fb5c879cb3e6b3d91cac9ab45e61b422bcf9ba5e89093466a65fa0907"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b48120133cbf055176d8b0c271f1397d664985c9829dc7fea4f850f1c8f1587"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454cea3f9879b9cf618e32636dbcdaf112eb9d8d642ab0ea63f4a506b8e554cc"
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
