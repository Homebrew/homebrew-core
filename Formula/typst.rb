class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "8532b4423fdb125c85a0dd15c8f8718d3135c394b0f8abe26b96a52d14c109c8"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/typst/typst.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d884397450cd2e1ae270313c7a7acc3c2619b4843dc588b0eaf13a356fd5fe5b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b9371edf9e327d1b1e3eef3d985988f7e7bac8345148542ea8d4eea9d6199dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "874d76d6d34e168a3b8e195e77181dbfa06dabe1dd330ceb858e26630fbc5b10"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a703a12c91d585f1c9f0a4467d42c429925d6673c747b48236fe799023ddd7"
    sha256 cellar: :any_skip_relocation, monterey:       "3affa0b7b11644f61014365fde77bfbbfeb0b4b06143ecb1f0b47a581f822756"
    sha256 cellar: :any_skip_relocation, big_sur:        "be2773f52ca6c481455fff5b1b1b877679ed01582c188227ff5afc343cfbc27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb05b32b2f7ff0e2e8fbeb5bff3e156e1155a2016f26219efd950993a91aff4b"
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
