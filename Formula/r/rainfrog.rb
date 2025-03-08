class Rainfrog < Formula
  desc "Database management TUI for Postgres"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.2.15.tar.gz"
  sha256 "166471abc5c0ec6dab47c56b6a6dfaa16efcb83e7dd826c489c0db96d19ab9f0"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43c207e6e3f6617f070218520750695fb613a5643b91de8b7fdf9236d34a2cdc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cba846f50f28ed7632416748c90418c3ab60b106ba33480a8787cb7630cc0ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "36c136603dfbf94c9e8e5d7635db6ee8c89878237339489d18c40b678bef3877"
    sha256 cellar: :any_skip_relocation, sonoma:        "fab04cd9a2ff5ae3013f75877b54a245acc82e38c5d305d9ccd8b2c4d0dc4f4d"
    sha256 cellar: :any_skip_relocation, ventura:       "8a6d8b2c2e00f0610689a36cc32242a6b6c4989b4cd9448b48715279bb087ed0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16818de9020d398326761c37b54aa2cf060d72d361c9bfeb666b8dc0bc1ada74"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # rainfrog is a TUI application
    assert_match version.to_s, shell_output("#{bin}/rainfrog --version")
  end
end
