class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.115.0.tgz"
  sha256 "97559fe62f73e476609d349f85ca0a4adc6a962080b127b0723e03bed83c5029"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "4c893b83513be6d264853f4da31ebc630d78c534c400f5e1f6115d5bc1594d77"
    sha256                               arm64_sequoia: "4c893b83513be6d264853f4da31ebc630d78c534c400f5e1f6115d5bc1594d77"
    sha256                               arm64_sonoma:  "4c893b83513be6d264853f4da31ebc630d78c534c400f5e1f6115d5bc1594d77"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd4e75ca78c4f4efbe7de9b92e11ac04463c9ec9c15259d6a3d26259ab372457"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb97f9b407790ac4680910014b064641d2f184d0050d19598817b3bcdb13970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d867726a126d52616e85d868f4b0d4bad5bd76bb725402c549e749c01dcd667f"
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
