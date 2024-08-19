class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "33b438017e17a9f68a1da09a40a022f88e8bca5315c0f80df82ba0aff4140c07"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92c24e3c204e998a6b38bda110eb1b7c10e63ee0aa027f6e98d4003a607b6f7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13c92bf518a767c950fc24de86df25b069c5ea9bccb973b27f33ae72dd7dff87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4873c4c2f83a44df745a9efddabf3e3a0c124b771b324f984c62a61490aefdb"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b1770bdeadc93c2db006bbdf20d1aabd5c411d25c8291c21267d2d2deaf7e2e"
    sha256 cellar: :any_skip_relocation, ventura:        "e9356ce4236472bafaadcc11d0ef60804989c3762e16afe4190fcbe2f6250ac4"
    sha256 cellar: :any_skip_relocation, monterey:       "aa12ba4bdb408aa61d0f3b84a7f54b134eacc9b2baa673e824a1c4759d699052"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85129a135b67ab96fae45ef3c37a18256f7710cc37f1af6e045cbe0ae2685786"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
