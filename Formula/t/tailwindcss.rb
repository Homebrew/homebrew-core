class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.1.13.tgz"
  sha256 "9d9b880b29190610af2ba8bcc8108b212f766c685393d0ac53a51f062f6eb056"
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
    sha256                               arm64_tahoe:   "37f13b869429ad703c83eab210fe0a81f648b97530ae4d2497ab73e760a9152f"
    sha256                               arm64_sequoia: "6e3446eb20430cec8acc63ddbb2011897c2c675517ad2db8353794594528ee03"
    sha256                               arm64_sonoma:  "2269f6ee703be749d8014ae88e9767d06c291b4f0dc96d3d321c9a2e33d8a9c7"
    sha256                               arm64_ventura: "e1be83ff20d210b8616f4bbcc777653b6246ace2a385978641f0815974bb6707"
    sha256                               sonoma:        "51d0158c0df06be7bd021e8b2378d5ffcb715dd3a4992eda7b12805459cbdcf0"
    sha256                               ventura:       "fda9e877f4cd53de24bac3585396feac2b36849c969eb17766dbed6b30239929"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed7c28df8c3c793983fcb512c5d41acd4b715f8ffd0418409e63e1c3c54b1073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a101e7634376dc6e146c01b2f0fcc3a93f25c68378e3169b9610c2ce3bdb3ba9"
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
