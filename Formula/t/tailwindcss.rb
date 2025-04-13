class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.1.3.tgz"
  sha256 "21ff69f902503f434a42a4d828b709e174606c0abbe7aef38035721638d3abc7"
  license "MIT"
  head "https://github.com/tailwindlabs/tailwindcss.git", branch: "next"

  # There can be a notable gap between when a version is added to npm and the
  # GitHub release is created, so we check the "latest" release on GitHub
  # instead of the default `Npm` check for the `stable` URL.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_sequoia: "ca9b0fc05a97c5d19ebc52d76e6cfc6d26c29c4655dd6e2a9d05de526ad41ed1"
    sha256                               arm64_sonoma:  "0074337a82ac94ae2c0d05249046c12699de1b6d79bfeef0e8f7ed758edbb0b8"
    sha256                               arm64_ventura: "73642b9dec8e52862e73af5b4bf6b06160ef04d9ba1cda8d2a57014f735619b8"
    sha256                               sonoma:        "2d41dade0d95b0596fc9b3eedb361a3b66739a0fb95b3f7ecde37b25622973e2"
    sha256                               ventura:       "c51f97181b82b2f4b1fc5182c13d8645fcc05c65c5cda82c87a54c642768a74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a26b0c631e66ffd3ce4ab22ba39c8401d036caa6288f2666d614de345bbd931"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11259257012c74a7e8a9f2dc191c626a2b3a40b124b9963c6b52cb9148a43868"
  end

  depends_on "node"

  # Imitate standalone CLI and include first-party plugins
  # https://github.com/tailwindlabs/tailwindcss/blob/main/packages/%40tailwindcss-standalone/package.json#L28-L31
  resource "@tailwindcss/aspect-ratio" do
    url "https://registry.npmjs.org/@tailwindcss/aspect-ratio/-/aspect-ratio-0.4.2.tgz"
    sha256 "858df3d82234e12e59e6f8bd5d272d1e6c65aefcb4263dac84d0331f5ef00455"
  end

  resource "@tailwindcss/forms" do
    url "https://registry.npmjs.org/@tailwindcss/forms/-/forms-0.5.10.tgz"
    sha256 "f5003f088c8bfeef2d2576932b0521e29f84b7ca68e59afd709fef75bd4fe9bb"
  end

  resource "@tailwindcss/typography" do
    url "https://registry.npmjs.org/@tailwindcss/typography/-/typography-0.5.16.tgz"
    sha256 "41bb083cd966434072dd8a151c8989e1cfa574eb5ba580b719da013d32b6828e"
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
