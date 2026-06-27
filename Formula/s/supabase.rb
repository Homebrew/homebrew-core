class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.108.0.tgz"
  sha256 "67802326e937ab4b97678c4db1bcf75052f4f96b91ae3d2c361719eb0f1b4e3b"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "ac729a09eecef2d8462340ef39d755249c288389fb214ea0ea060379cff96371"
    sha256                               arm64_sequoia: "ac729a09eecef2d8462340ef39d755249c288389fb214ea0ea060379cff96371"
    sha256                               arm64_sonoma:  "ac729a09eecef2d8462340ef39d755249c288389fb214ea0ea060379cff96371"
    sha256 cellar: :any_skip_relocation, sonoma:        "7473f8f205ae8884f81ffc9a06712d259d94d128699e15352e4692c43a3f548c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a13aa2706a747e04215ca0e5875a74d54aa64bafaa8bbd1393425a1f2b4e1a56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6653b15313f02f3d4fd0f9c564c9303f58dff89baf2f998a832ec3ed5c1acf28"
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
