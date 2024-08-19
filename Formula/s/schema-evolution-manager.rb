class SchemaEvolutionManager < Formula
  desc "Manage postgresql database schema migrations"
  homepage "https://github.com/mbryzek/schema-evolution-manager"
  url "https://github.com/mbryzek/schema-evolution-manager/archive/refs/tags/0.9.54.tar.gz"
  sha256 "8d1f3ec1673f3da8b423866ee9b1ceb6e6492ef723022884a39f2097c05a5410"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, sonoma:         "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, ventura:        "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, monterey:       "da0a8735eecd1efe0602386929a515ae4bf9df6e49014963f2a74e5693ac2505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20071cf2c6a18e15cee9ca71adcd1bc77b5d73e899263bb9a8bd918cf3cbaefd"
  end

  uses_from_macos "ruby"

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"new.sql").write <<~EOS
      CREATE TABLE IF NOT EXISTS test (id text);
    EOS
    system "git", "init", "."
    assert_match "File staged in git", shell_output("#{bin}/sem-add ./new.sql")
  end
end
