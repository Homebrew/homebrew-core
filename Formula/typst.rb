class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "f52e1cab191034354b3adaa97c27cbf16ed99486dc302b014bf211a8b6a7e964"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1817abc0d9990bcf03301a9ef25b02427b9bbe935bfa34cb00cf6ec560e70919"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5dd6ddecc373b42bb19d08e1325ae9afc90936d41d98215f8af19af6916e714"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fca083b602ea8bb148941a2df934447d13a87b61bcac825d382ae69be4efffc"
    sha256 cellar: :any_skip_relocation, ventura:        "5b36644479916e0f0eb69c4a102cc3b1b40bbba7d03f628e7bafa352670a4c90"
    sha256 cellar: :any_skip_relocation, monterey:       "6868dc6d6519386d411dbca5ed6561b52982c3155d1e0d09de05a12ddf2399ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cb27ef79689871a17bc5507e761b5293f1fd06390e21746196ae882bfc233a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ef97a3460690458777f10b895c289b2ad21956c6c7f1599c39645fbc880c214"
  end

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", "compile", "Hello.typ", "Hello.pdf"
    assert_predicate testpath/"Hello.pdf", :exist?

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
