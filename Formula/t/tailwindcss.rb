class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.3.5.tgz"
  sha256 "889bc319dc2650a68aed225fac2b4d017f64d3964e3b9e66fd87f2737fc38f32"
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
    sha256 cellar: :any,                 arm64_golden_gate: "c16b2dbc4151f2e39b77063afc398a6cd8b26f2c12c01e58484c3b060037da5a"
    sha256 cellar: :any,                 arm64_tahoe:       "c16b2dbc4151f2e39b77063afc398a6cd8b26f2c12c01e58484c3b060037da5a"
    sha256 cellar: :any,                 arm64_sequoia:     "c16b2dbc4151f2e39b77063afc398a6cd8b26f2c12c01e58484c3b060037da5a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3a15e3795eb83b951fe5300b4a181635e84a20e2478b0f760c27ef0195ed00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "706cb4d7c77f3ed5ab1b9d848b174bf43d3a1c1ba72f987bc184b8824be1c2f3"
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
