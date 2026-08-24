class YuqueDl < Formula
  desc "Knowledge base downloader for Yuque"
  homepage "https://github.com/gxr404/yuque-dl"
  url "https://registry.npmjs.org/yuque-dl/-/yuque-dl-1.0.86.tgz"
  sha256 "930933a0c719613e26a8015d26b6cbfcd4ba314392929939c05b6ac635980177"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "26aad01be03c784d3b784455153ffd38a4fe2df2a17c5c4240b877319f59c7c2"
    sha256 cellar: :any,                 arm64_sequoia: "26aad01be03c784d3b784455153ffd38a4fe2df2a17c5c4240b877319f59c7c2"
    sha256 cellar: :any,                 arm64_sonoma:  "26aad01be03c784d3b784455153ffd38a4fe2df2a17c5c4240b877319f59c7c2"
    sha256 cellar: :any,                 sonoma:        "41ddca92b75d9dd330f9cf42df37426508ce7b078579f8064aa7daa44e3455e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b8f29c3b2bd4f37d1f72d8b8d0cb485fa861b1d42b9edcbca42dd1881c3dd410"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97fd711effdf52b479e05b753443efed9bd5d0c2a8704e22ef8bcade6f09a984"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/yuque-dl/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yuque-dl --version")

    assert_match "Please enter a valid URL", shell_output("#{bin}/yuque-dl test 2>&1", 1)
  end
end
