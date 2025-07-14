class Rasusa < Formula
  desc "Randomly subsample sequencing reads or alignments"
  homepage "https://doi.org/10.21105/joss.03941"
  url "https://github.com/mbhall88/rasusa/archive/refs/tags/2.1.0.tar.gz"
  sha256 "6d6d97f381bea5a4d070ef7bc132224f3c5c97bc366109261182aa9bc5736d69"
  license "MIT"
  head "https://github.com/mbhall88/rasusa.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e1af923ce8e04dcdd10bfdc1f9c66bac275a886116d15b667826cff63b0492"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bf0ea2e9e8e13e931b0fc36401707d60e00a410acecc146340530dc41afdc8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2749a2a0a451847ca5c4ea5e09ce87dd74baf26de4ef2d6ac39f8d9295238a84"
    sha256 cellar: :any_skip_relocation, sonoma:        "2637f18df52d2a9dbec4bd7f3e66cde0fa19e5c745e9b7bff2d72074ee8f9b66"
    sha256 cellar: :any_skip_relocation, ventura:       "03131f99f31427cc19cde537f7f692dc749ce8a9c729c8bc5f6c9500b2e1fec4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cd1abb5b0dfb480f57964e96d0fe9c223b672fb5b6df20a0144b80186c47003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56b2672126342fb35d4f8332c6aeb5ed57be484bba73e405342ee205a12fca6c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    pkgshare.install "tests/cases"
  end

  test do
    cp_r pkgshare/"cases/.", testpath
    system bin/"rasusa", "reads", "-n", "5m", "-o", "out.fq", "file1.fq.gz"
    assert_path_exists "out.fq"
  end
end
