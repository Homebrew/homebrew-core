class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://github.com/LucasPickering/slumber/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "14319206deb7691b44d074caa32837b4a6dad558ced5f68d0666671a0fb25089"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "48f71c3b1ed761714918211b9adca95411bc80c759e7da7b8aa2dd0725798087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d9fdf7beb9bd23dddb5571697883b49b605a7095b8255358d10629dde10a7ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a59bff7aae676dae1bf41bedb0a448aaaaa16fdb4623d705a4bbd8dfa5359da5"
    sha256 cellar: :any_skip_relocation, sonoma:        "b99f4fa4986619733ff51ebbe77c981f7bb749a9e0f2c472c32b9e9bfdf21f3c"
    sha256 cellar: :any_skip_relocation, ventura:       "d61cfc364cbb000a834a4a1ba1ca968f7373aa4cad83ea2de2af9e3d0409a2d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f9b9aab46ec7c5b6f5e781800bffca45cb61970159e57113b516f3fa97d9b7b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      # For basic usage info, see:
      # https://slumber.lucaspickering.me/book/getting_started.html
      # For all collection options, see:
      # https://slumber.lucaspickering.me/book/api/request_collection/index.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https://httpbin.org
    YAML
  end
end
