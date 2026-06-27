class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.3.1.tgz"
  sha256 "b533ba6def606b2a2da21f77df30140d79aad22ca956efbe270ef14aef42ea65"
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
    sha256 cellar: :any,                 arm64_tahoe:   "1d650c5a650bfed5bc89762eb5ee3a612769e662172be3906f58af6e6e148a64"
    sha256 cellar: :any,                 arm64_sequoia: "dbc4271a15103d49cef495b3fc01b0217ad3f0f27c5efc564bdac657feb2c05f"
    sha256 cellar: :any,                 arm64_sonoma:  "dbc4271a15103d49cef495b3fc01b0217ad3f0f27c5efc564bdac657feb2c05f"
    sha256 cellar: :any,                 sonoma:        "4c0c549df6b2d7a2737a787b9b08bbafd4cd2e902d00bc0f78c179624d6f6c19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10cb7492d4eb3d704f8462cea054b9bbc772d35001221ac49a59d3b300192d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59d9db3e00146318861f9c5b55e6c36c2002324c8fec9c1fe12c4e9ad53ddc32"
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
    url "https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.20.tgz"
    sha256 "a4744ab51d0e2bdbb84a0c7e3af7163f38e567efc2bb2c56a039e45c6643b7c4"
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
