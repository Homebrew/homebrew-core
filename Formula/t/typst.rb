class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "550fb66bb3405951dfd0a1736e9e17756e906e664f6f683eeb87d40643218846"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eb730d393a17fdd9109f61bed3c94c4565e860b2b7659739d6229ce9d13756c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e3abc38a8fd93ae0bf2ed2e080b9e5694d1bdafa1c2f434830d445f31d3968"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802353ae8b770ff7eeaa1fe5be56bf3708d662de5ee4c5e31cbb1d8a4bfc4d45"
    sha256 cellar: :any_skip_relocation, ventura:        "5e5ea3bd23499f7a4908ff8d4992bee7757ceb35a0dd95d598bd11bf40a6bc62"
    sha256 cellar: :any_skip_relocation, monterey:       "b92a357fb14e9a8454abd223789250d9671ac2b44e298b5359f0b2b94e1cd2e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aee4ee0203020ec7c51cf1d1ea292ce12a6fb4b1d7eee084338fc479c0d9346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927f53ad149d29ce9e43f68a7e9d9436c04721f37697a80c6f7ea51e0f6424b3"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "crates/typst-cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
