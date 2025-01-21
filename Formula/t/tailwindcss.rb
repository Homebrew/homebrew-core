class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-3.4.17.tgz"
  sha256 "c42aab85fa6442055980e2ce61b4328f64a25abef44907feb75bd90681331d2a"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "470d9bbfd904d02d77d565faa66afddcb033b7030ff41baf28ad47294c65c4b5"
    sha256 cellar: :any_skip_relocation, ventura:       "470d9bbfd904d02d77d565faa66afddcb033b7030ff41baf28ad47294c65c4b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6642f35504e8ab8ce029025e265972bb9a74d9030bd879973388ba245f5707ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath/"output.css"
  end
end
