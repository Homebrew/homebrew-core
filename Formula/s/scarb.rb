class Scarb < Formula
  desc "Cairo package manager"
  homepage "https://docs.swmansion.com/scarb/"
  url "https://github.com/software-mansion/scarb/archive/refs/tags/v2.12.2.tar.gz"
  sha256 "69a37170a5e352da835fe2101ef6bfd8cef952411f86ba8a23d2d96ab6931fe8"
  license "MIT"
  head "https://github.com/software-mansion/scarb.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d8b70f3e241a1e6eeaeb9193c1962624633910f0843a038629011a7248e1d57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f725bbcdf57df264acbff40d2a829fe5d4e0721dfca785828be0c41ff1065ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cde688a72cc73bf4ac68645d49e72cadeec612f8092abb622102cea7aa100c33"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe7107120aed3068864143ddbbbdb8436c6133ba4c0a8083afcb8694f28e1976"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eab8e589ff95c270de43dce6504d07ded7eace174a10b45b3595e85597b769a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cee6486b22d60d5944efdbab3c913c76f2eb149c6cd1d7335902de8bc551debe"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  def install
    %w[
      scarb
      extensions/scarb-cairo-language-server
      extensions/scarb-cairo-run
      extensions/scarb-cairo-test
      extensions/scarb-doc
    ].each do |f|
      system "cargo", "install", *std_cargo_args(path: f)
    end
  end

  test do
    ENV["SCARB_INIT_TEST_RUNNER"] = "cairo-test"

    assert_match "#{testpath}/Scarb.toml", shell_output("#{bin}/scarb manifest-path")

    system bin/"scarb", "init", "--name", "brewtest", "--no-vcs"
    assert_path_exists testpath/"src/lib.cairo"
    assert_match "brewtest", (testpath/"Scarb.toml").read

    assert_match version.to_s, shell_output("#{bin}/scarb --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-run --version")
    assert_match version.to_s, shell_output("#{bin}/scarb cairo-test --version")
    assert_match version.to_s, shell_output("#{bin}/scarb doc --version")
  end
end
