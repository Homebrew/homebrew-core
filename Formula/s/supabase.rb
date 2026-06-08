class Supabase < Formula
  desc "Postgres development platform"
  homepage "https://supabase.com/docs/reference/cli/about"
  url "https://registry.npmjs.org/supabase/-/supabase-2.105.0.tgz"
  sha256 "6915a934748bf1e532de2e18a473da340fd277399e4670358bab479da1c67064"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "c865723e4a356f2b031e929d384deaba27feccb0f2f62e2e8a105300566c31f0"
    sha256                               arm64_sequoia: "c865723e4a356f2b031e929d384deaba27feccb0f2f62e2e8a105300566c31f0"
    sha256                               arm64_sonoma:  "c865723e4a356f2b031e929d384deaba27feccb0f2f62e2e8a105300566c31f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd0dddf70ff0303a525dae009cfe10aa0a1be9b5d91f94589a705bc4f6bb3651"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d3e731d0ba491c40da86683e3c53fb580b8640fc409e80eca532fe94447d0d2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "404d3543f28bc24b30e5ab38fe23b691c6ed191d8b63d070da4d8fa45d681098"
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
