class Rainfrog < Formula
  desc "Database management TUI for PostgreSQL/MySQL/SQLite"
  homepage "https://github.com/achristmascarl/rainfrog"
  url "https://github.com/achristmascarl/rainfrog/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "1d9322296b8fb0c789ad3a3b13284f39e15a55efb479b3d2e2d5954ec3c0ea73"
  license "MIT"
  head "https://github.com/achristmascarl/rainfrog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c79ef2b4ba211d4957702a3550fb2911816f244b0ddf4676889d1622b9924237"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a63f178ce7b841bb24f6fa173a25fb860dfee41c62b0da1d4c1fd322db1b3c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d56fd3a2a03d6ab4143457afd90e840c10e0505e460ce9a51c118d1c37c4f424"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2fc15b3083b8fdd0ce97fa9ec906cdd9f962fbfe0f85a271620a052e287ed00"
    sha256 cellar: :any_skip_relocation, ventura:       "bd148b7a454d58311e436a1b8d6c1f525565a1244da92a1a1fc2bbdd5a6afe85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b35d6d00b7889ce87f61dd54b013a6137c5d9772e943db2a9692313ae617c83b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a1ac5a817eaefe588822cc6eaba8a1af081220308b099960890291ae5db48b7"
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
