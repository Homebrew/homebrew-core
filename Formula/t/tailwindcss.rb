class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.3.0.tgz"
  sha256 "4feba167e62643b6089c139b9eed765ca270e264b2690df689ef996f417de9de"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "main"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "447f36adfedb96b2f60b6f615d2bb0503910db18b82ed4d50c8ddeee75054568"
    sha256 cellar: :any,                 arm64_sequoia: "f3a2d694999327bbbac21a778a1474b7a65a47d3a2bade3efe7cfc78e3132dc1"
    sha256 cellar: :any,                 arm64_sonoma:  "f3a2d694999327bbbac21a778a1474b7a65a47d3a2bade3efe7cfc78e3132dc1"
    sha256 cellar: :any,                 sonoma:        "6b09362cd53defee187512b96bf156e75581648bbbe5e64f2c257c82859c1998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fe434f656eaf69bb6e2c0b370f56774ab25348de6215e2c4026e0d2e42a0a9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1fc1180fe8638008e47eade6b38fab546408845d94348f1467e21cb8ab8807d"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https://github.com/tailwindlabs/tailwindcss/blob/main/packages/%40tailwindcss-standalone/package.json#L28-L31
  resource "@tailwindcss/aspect-ratio" do
    url "https://registry.npmjs.org/@tailwindcss/aspect-ratio/-/aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcss/forms" do
    url "https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.11.tgz"
    sha256 "6180fcab09668a498d17c89ca11b54825c5ee6b6fc6d1343ad6fa558d9828c50"
  end

  resource "@tailwindcss/typography" do
    url "https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.19.tgz"
    sha256 "0490006975cde689af548a2755f9c263344b7896f7fcc1d6b6f6680b59af3465"
  end

  def install
    system "npm", "install", *std_npm_args

    cli_libexec = libexec/"lib/node_modules/@tailwindcss/cli"
    resources.each do |r|
      system "npm", "install", "--prefix", cli_libexec, *std_npm_args(prefix: false), r.cached_download
    end

    bin.install libexec.glob("bin/*")
    bin.env_script_all_files libexec/"bin", NODE_PATH: libexec/"lib/node_modules/@tailwindcss/cli/node_modules"
  end

  test do
    # https://github.com/tailwindlabs/tailwindcss/blob/main/integrations/cli/standalone.test.ts
    (testpath/"index.html").write <<~HTML
      <div className="prose">
        <h1>Headline</h1>
      </div>
      <input type="text" class="form-input" />
      <div class="aspect-w-16"></div>
    HTML

    (testpath/"input.css").write <<~CSS
      @tailwind base;
      @import "tailwindcss";
      @import "tailwindcss/theme" theme(reference);
      @import "tailwindcss/utilities";

      @plugin "@tailwindcss/forms";
      @plugin "@tailwindcss/typography";
      @plugin "@tailwindcss/aspect-ratio";
    CSS

    system bin/"tailwindcss", "--input", "input.css", "--output", "output.css"
    assert_path_exists testpath/"output.css"

    output = (testpath/"output.css").read
    assert_match ".form-input {", output
    assert_match ".prose {", output
    assert_match ".aspect-w-16 {", output
  end
end
