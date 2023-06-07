class Rnr < Formula
  desc "Command-line tool to batch rename files and directories"
  homepage "https://github.com/ismaelgv/rnr"
  url "https://github.com/ismaelgv/rnr/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "cde8e5366552263300e60133b82f6a3868aeced2fe83abc91c2168085dff0998"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13e613c2d00e9e996d6b0bd2b43e1e23bc60f4a5a6d5f0e1a7c33058be9cd98e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47dbe0a3e417a52175e9af2d05752ba236ff850f6278b8829efc1a60bdbcb55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df46ce33f22472a8c3869bd61f8832340953469bc721b9091e04f35fcc4dea7b"
    sha256 cellar: :any_skip_relocation, ventura:        "e7a1f0fbe20e79691075d96a574c6a55adf50bb2e5339242ca9b2b4ab08c1d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "5d77ebcc4d57548d2c95f5c5753e917896627e9ea117f6e4c05861d18b39408b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd2d7d0aafdd9699adc98bfcf5d56c8af2402ed2ae12789734de2fb0471f7380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a837c604ac4157d95b648d0b9a4885287868eccf522e44f002d06096dc9145a5"
  end

  depends_on "rust" => :build

  def install
    ENV["SHELL_COMPLETIONS_DIR"] = buildpath
    system "cargo", "install", *std_cargo_args

    deploy_dir = Dir["target/release/build/rnr-*/out"].first
    zsh_completion.install "#{deploy_dir}/_rnr" => "_rnr"
    bash_completion.install "#{deploy_dir}/rnr.bash" => "rnr"
    fish_completion.install "#{deploy_dir}/rnr.fish"
  end

  test do
    touch "foo.doc"
    mkdir "one"
    touch "one/foo.doc"

    system "#{bin}/rnr", "-f", "doc", "txt", "foo.doc", "one/foo.doc"
    refute_predicate testpath/"foo.doc", :exist?
    assert_predicate testpath/"foo.txt", :exist?
  end
end
