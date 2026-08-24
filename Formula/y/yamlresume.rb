class Yamlresume < Formula
  desc "Resumes as code in YAML"
  homepage "https://github.com/yamlresume/yamlresume"
  url "https://registry.npmjs.org/yamlresume/-/yamlresume-0.15.0.tgz"
  sha256 "4a0b26415aa2f923958b272a3a57da05543478f8006ad7ba13c8295b82ecd257"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d41f16908845a583cb433d9f83727f369eecc1cb9538d7899694c071ea4a12e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9c22b6cf49e43c8292e49735ac5e90d63886a1d6fa95381db5dd5c8df6ef64c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ede5473b63d0bf5d5d2a3b07db6f3387ebf13e8edb1e7e8b979c3ee9ae2b2aaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "4433fb476c344a11427caaac46519b0b7667b7316217a71fe6e19806ed2ec1d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "37f4160bd9bb2409919003021306b3f9bc4b226b6d83a7b4265985acbbb64193"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37f4160bd9bb2409919003021306b3f9bc4b226b6d83a7b4265985acbbb64193"
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
