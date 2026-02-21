class Razin < Formula
  include Language::Python::Virtualenv

  desc "Static analysis scanner for SKILL.md-defined agent skills"
  homepage "https://theinfosecguy.github.io/razin/"
  url "https://files.pythonhosted.org/packages/44/66/25c738e8cf47f5bc79f5a66961252b48a26fcf40cb373fbc454cfa2389e6/razin-1.3.2.tar.gz"
  sha256 "5198564d7417dcd53c1e8e1cac7d9271d6cf07e333d36b9142107d7094836b77"
  license "MIT"

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    skill_dir = testpath/"sample"
    skill_dir.mkpath
    (skill_dir/"SKILL.md").write <<~MARKDOWN
      ---
      name: sample-skill
      ---
      # Sample
      command: run-this
    MARKDOWN

    shell_output("#{bin}/razin --version")
    system bin/"razin", "scan", "-r", testpath.to_s, "-o", (testpath/"output").to_s, "--no-stdout"
    assert_path_exists testpath/"output"/"sample-skill"/"summary.json"
  end
end
