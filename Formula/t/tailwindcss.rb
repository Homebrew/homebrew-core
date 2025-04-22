class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.1.4.tgz"
  sha256 "ecdf993c910fc985c200e95bb6d4bf03d7309372dbd873c17807e21bd99c6fd2"
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
    sha256                               arm64_sequoia: "239459b8388b0466428b1aa721d7a079250aba83979251fe9f003f60cd638c13"
    sha256                               arm64_sonoma:  "961367eab1d0c8c8b8704f937c0e4e255b85f6bfdeac66eff3516c1a9e8d40e0"
    sha256                               arm64_ventura: "a71b259c6c5cc2b66b50ad0b16a910af88b53f6052314133a3a7ee0613708ccf"
    sha256                               sonoma:        "0cf19733a20c582a0d4f60b40c6f0d3b4687e35cceff1210d055004887e264b3"
    sha256                               ventura:       "1e6aab457a66e9867f61c0f4a1e7f2fa99f7c9f7c6ad63d393c256203dcfd024"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163f28f83f1b32f26e3db640ba399b1837e9b1f611844a6ceb9a868a67931f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2319cbb8ca4d53b2893e988de64fb04ea43382304646ce3bf26a23a97a93c10"
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
