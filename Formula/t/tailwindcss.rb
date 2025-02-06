class Tailwindcss < Formula
  desc "Utility-first CSS framework"
  homepage "https://tailwindcss.com"
  url "https://registry.npmjs.org/tailwindcss/-/tailwindcss-4.0.3.tgz"
  sha256 "8b5a00d0c29cfce9ec97cde2144a40a279c133a42074f5d1d9958b8efee1495a"
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
    sha256                               arm64_sequoia: "b541bf977c9cc588f95bb3ce310a5e84127e994d16c19d30b350b62646f134d2"
    sha256                               arm64_sonoma:  "6b52cf6468e3c71a85ce19cb24b38ee6aad73ff8bf224b300b84bd660a5af77a"
    sha256                               arm64_ventura: "c7b7ffdeb80383280c0411c12056534d4bda92cd5d31ef56433a136da05e24e7"
    sha256                               sonoma:        "35a3c99f7aee5dcfa2ca87209b2d3a6ec804015ad96452b1abd4be4ce235ecd8"
    sha256                               ventura:       "4c5805491ecfd665f7cdea75985f580e1949a5157d53bf4b15fe5e1abad5c9bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6aabde954bdd96b8f7b02317eff08e53ca767965d30596c57180b998fc4091d"
  end

  depends_on "node"

  resource "tailwind-cli" do
    url "https://registry.npmjs.org/@tailwindcss/cli/-/cli-4.0.3.tgz"
    sha256 "d9df4e36cd823bbf90aeb9f7dc8e1bd1886501ef0ff51cba83526d29a41d5402"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "tailwind-cli resource needs to be updated" if version != resource("tailwind-cli").version

    # install the dedicated tailwind-cli package
    resource("tailwind-cli").stage do
      system "npm", "install", *std_npm_args
    end

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"input.css").write("@tailwind base;")
    system bin/"tailwindcss", "-i", "input.css", "-o", "output.css"
    assert_path_exists testpath/"output.css"
  end
end
