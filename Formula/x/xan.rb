class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https://github.com/medialab/xan"
  url "https://github.com/medialab/xan/archive/refs/tags/0.59.0.tar.gz"
  sha256 "b2c101c85fb1b0e98f80aa2117e93c5381cc6483e199cbe6796da4a275511e20"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/medialab/xan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9f6aea0530c9944cd769d6760f6aeee47a0616ffe17ddb5da1613cf13f06ce6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c3e9c7a7e513227760fab0781692bc04ffc037dda382141597f9c29406667daf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94f6786c71086f4c49e306cc0b911610d88fe6708a8ff1bf210b0fb0db05a0ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "60b8bbb6de5238bee503a964bb33dae9cfd5c8559423a0cfa4e34fc1ec28f699"
    sha256 cellar: :any,                 arm64_linux:   "a4cb58257c15ea36f1199ce0d755f3436d03542e12cd25873d62cf0648b607ef"
    sha256 cellar: :any,                 x86_64_linux:  "83c555db34eebf9ae7c61e727cdcaea7a535f17455e3dcdba94cffdf3580d4fe"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(features: "parquet")
    generate_completions_from_executable(bin/"xan", "completions", shells: [:bash, :zsh])
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    system bin/"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}/xan --version").chomp
  end
end
