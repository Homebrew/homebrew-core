class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.2.2.tgz"
  sha256 "3b942287fd9bc6a28c935f33871ef947444dfb0c11a7c7206e40765f190a0791"
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
    sha256 cellar: :any,                 arm64_tahoe:   "40219adfc4514ed21280b06c6166041f4ca4aeca7557cd2a723a8b1f9d0f7d4e"
    sha256 cellar: :any,                 arm64_sequoia: "9a05c555ea084c7e77cc6093d6aee01b9e9739a9429319d4798fc7e90602635b"
    sha256 cellar: :any,                 arm64_sonoma:  "9a05c555ea084c7e77cc6093d6aee01b9e9739a9429319d4798fc7e90602635b"
    sha256 cellar: :any,                 sonoma:        "6cb28c23cfc03ec43175bb798241e7945853f322f43cc7e57562ba1db6c09c26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "323fccf36241e1123c68e3b36414eb9fe49515105482539967ae3012b0cc6085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5075b2968e2d25a58ab313896bad32af4ce0416e21f10cdf328c0de1f188f23e"
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
    resources.each do |r|
      system "npm", "install", *std_npm_args(prefix: false), r.cached_download
    end
    system "npm", "install", *std_npm_args
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
