class RvR < Formula
  desc "Declarative R package manager"
  homepage "https://a2-ai.github.io/rv-docs/"
  url "https://github.com/A2-ai/rv/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "666de33555efd68ab5342d9d10954a3c1b367eca7008b157637da64d22f61f40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d94a25605df1043403c9861d5e638206aee59835d2b378606bd139a789dfdb95"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9276b9c2f83f7565dafc33de5cb9ddef7a09e461d020782914270ef2cb29938d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "534ea3e2a25379c8c4155d080dd526096980ad88be7271fb936d5eba423c8de6"
    sha256 cellar: :any_skip_relocation, sonoma:        "779101b806d5fc37096f09cbaf2f4a6d8bd77acf727d6f1af84f2830f904f194"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "400f1e21f0091df2acbeadafb17ee7cbdc2d65ad043d5daf7569f251d187ed73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84d570f96cd5279b7d2650d85211ce14ec2a6b337fe52bb512182b30949d29e2"
  end

  depends_on "rust" => :build
  depends_on "r" => :test

  conflicts_with "rv", because: "both install `rv` binary"

  def install
    system "cargo", "install", *std_cargo_args(features: "cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rv --version")
    system bin/"rv", "init"
    assert_path_exists "rproject.toml"
  end
end
