class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.109.1.tgz"
  sha256 "28471926912a7d3494daba02d5968b140158199e11e0cfc06a2887f53d19bc06"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "67c7264529153783be9379e7ee17e5246d6522d67575c2e90825a94fe026f0bc"
    sha256                               arm64_sequoia: "67c7264529153783be9379e7ee17e5246d6522d67575c2e90825a94fe026f0bc"
    sha256                               arm64_sonoma:  "67c7264529153783be9379e7ee17e5246d6522d67575c2e90825a94fe026f0bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a225c587a9b64a4069aee2b42d45e612845e00a7c425aa0c145ab823a71790b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "866abf0772e767d0b7efdf9c0b2af87bb31074758b05861c723d095c2c3e736f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83bdc384eaba7a5270128dc5143982e6466e749d7e6fda7ab0b135f2ad27e927"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/supabase --version")

    system bin/"supabase", "init", "--yes"
    assert_path_exists testpath/"supabase/config.toml"
    assert_match "failed to inspect container health", shell_output("#{bin}/supabase status 2>&1", 1)
    assert_match "Access token not provided", shell_output("#{bin}/supabase projects list 2>&1", 1)
  end
end
