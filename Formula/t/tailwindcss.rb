class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.3.4.tgz"
  sha256 "3e3cfc6452192414f67f2feb58503d4651efc2b78c7390689a9ed4e125d54207"
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
    sha256 cellar: :any,                 arm64_golden_gate: "20759c1d1c19d81663b508345b2a61ce704156311c821d939b5caf2ed3823bd7"
    sha256 cellar: :any,                 arm64_tahoe:       "20759c1d1c19d81663b508345b2a61ce704156311c821d939b5caf2ed3823bd7"
    sha256 cellar: :any,                 arm64_sequoia:     "20759c1d1c19d81663b508345b2a61ce704156311c821d939b5caf2ed3823bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3d4cd5fc32b2b5ecccbe733dabf43fd2d0ef3d8367417de8eb8ada24f49b6374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "070cb871ecf66042118fde5e357263886cea2b9a10cffc21ca97f285dbfcc32a"
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
