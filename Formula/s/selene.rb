class Selene < Formula
  desc "Blazing-fast modern Lua linter"
  homepage "https://kampfkarren.github.io/selene"
  url "https://github.com/Kampfkarren/selene/archive/refs/tags/0.26.1.tar.gz"
  sha256 "44a4485b880aca3a70970167faa6cd467418cb49ddfb3b87fe616af7462180fd"
  license "MPL-2.0"
  head "https://github.com/Kampfkarren/selene.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8be32b99bd7c582742f8a57d7483e53749bf777bea0e835884e2d8377b98bce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbb8ae0eef4c8f53481bd6f81e6029c39835e710371d648b97b3da079552e154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552eb2fa15999c6a702c20a670cb152f6eb33687513feec266b341ac6cf2b503"
    sha256 cellar: :any_skip_relocation, sonoma:         "d7b5010660fd55fdf50c7dbca71e0f38a3da6a0eeb0905bb59cd1a37c711187b"
    sha256 cellar: :any_skip_relocation, ventura:        "c78d099a304c4641be142d970abc4393c9ec9449ebb7dacdc457c007481037ff"
    sha256 cellar: :any_skip_relocation, monterey:       "92b1773ac7dea42d0ddef56f7d5c5c977d44a20d51c17c1fcbafd5b0a328df45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "194a76463eb92d1f147b0bff825214a9137fdbf32d2491d1152d8c3e1a634297"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    cd "selene" do
      system "cargo", "install", "--bin", "selene", *std_cargo_args
    end
  end

  test do
    (testpath/"selene.toml").write("std = \"lua52\"")
    (testpath/"test.lua").write("print(1 / 0)")
    assert_match "warning[divide_by_zero]", shell_output("#{bin}/selene #{testpath}/test.lua", 1)
  end
end
