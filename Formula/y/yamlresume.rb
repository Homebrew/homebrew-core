class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.13.2.tgz"
  sha256 "daae042b98995ddb38154c9300e7a114353a8e4862874cb33f2332bc6e7fa7d5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "603d1c5063a872b5ef90e9f715b6b7877f7fc24473a20a1d37590005976ff30f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fd28581f4c1d7ed870dfc905d0b428fe32e601dfd81c84c0b6ad06dbc316c4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b0880fcdfa1b8830b3d25e29d256a8e4d1a85da0675f61883ce6c8dcb48a938a"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a4f4b7695d3081053da14b97d513b164840e90e5482ae31c75ddee0f8074cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef015259f7c0cc6075289c7468448211401616369e1f8a0bfff94cfa40c73877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef015259f7c0cc6075289c7468448211401616369e1f8a0bfff94cfa40c73877"
  end

  depends_on "node"

  on_linux do
    depends_on "fontconfig" # for font-list to run fc-list
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    # Replace prebuilt binary by compiling based on upstream build script:
    # https://github.com/oldj/node-font-list/blob/master/scripts/build-darwin.sh
    cd libexec/"lib/node_modules/yamlresume/node_modules/font-list/libs/darwin" do
      rm("fontlist")
      system ENV.cc, "fontlist.m", "-framework", "AppKit", "-framework", "Foundation", "-o", "fontlist"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yamlresume --version")

    system bin/"yamlresume", "new"
    assert_match "YAMLResume provides a builtin schema", (testpath/"resume.yml").read

    output = shell_output("#{bin}/yamlresume validate resume.yml")
    assert_match "Resume validation passed", output
  end
end
