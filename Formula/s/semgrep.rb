class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/semgrep/semgrep.git",
      tag:      "v1.128.0",
      revision: "aee37f5e693985ba3de1badb459f24f18af96624"
  license "LGPL-2.1-only"
  head "https://github.com/semgrep/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "be36d97daac81920674b15e70d53239aad1fd394566fbc81450e34f65d11c953"
    sha256 cellar: :any,                 arm64_sonoma:  "6e02103c38a5a465930273f19ddabe7fbdb7416293958a971d21b7e98699c89a"
    sha256 cellar: :any,                 arm64_ventura: "545f2b93529498e0b06e2cbe6ab7523a8719978efc36f3ba762edaf088408bc8"
    sha256 cellar: :any,                 sonoma:        "05c3c0886a5dc3300a7e2be40c406214eb9d6d1eaf392ae7782d6cea58cbb823"
    sha256 cellar: :any,                 ventura:       "445c58923aa231640f5df0745f4d8352cd5c8d26b234987073b716b6e19c54a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "709a28e3273817129605d2aca8082dc893445463df06ad2b172bd2db8226a6ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe3dd32c560bdc4db638c130ce45746d8763db915cc557cf14d530762c462a1"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pipenv" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre"
  depends_on "pcre2"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "tree-sitter"
  depends_on "zstd"

  uses_from_macos "rsync" => :build
  uses_from_macos "curl"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/b9/9f/1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76/click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/98/97/06afe62762c9a8a86af0cfb7bfdab22a43ad17138b07af5b1a58442690a2/deprecated-1.2.18.tar.gz"
    sha256 "422b6f6d859da6f2ef57857761bfb392480502a64c3028ca9bbe86085d72115d"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/09/35/2495c4ac46b980e4ca1f6ad6db102322ef3ad2410b79fdde159a4b0f3b92/exceptiongroup-1.2.2.tar.gz"
    sha256 "47c2edf7c6738fafb49fd34290706d1a1a2f4d1c6df275526b62cbb4aa5393cc"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/ac/79/2484075a8549cd64beae697a8f664dee69a5ccf3a7439ee40c8f93c1978a/face-24.0.0.tar.gz"
    sha256 "611e29a01ac5970f0077f9c577e746d48c082588b411b33a0dd55c4d872949f6"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/39/24/33db22342cf4a2ea27c9955e6713140fedd51e8b141b5ce5260897020f1a/googleapis_common_protos-1.70.0.tar.gz"
    sha256 "0e1b44e0ea153e6594f9f394fef15193a68aaaea2d843f83e2742717ca753257"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/bf/d3/1cf5326b923a53515d8f3a2cd442e6d7e94fcc444716e879ea70a0ce3177/jsonschema-4.24.0.tar.gz"
    sha256 "0b4e8069eb12aedfa881333004bccaec24ecef5a8a6a4b6df142b2cc9599d196"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/df/0d/10357006dc10fc65f7c7b46c18232e466e355f9e606ac461cfc7193b4cbe/opentelemetry_api-1.25.0.tar.gz"
    sha256 "77c4985f62f2614e42ce77ee4c9da5fa5f0bc1e1821085e9a47533a9323ae869"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/37/a7/85ffaaacd712e4634fa1c56cbf79a02cf90b8a178fe1eee2cabfb0b7f44d/opentelemetry_exporter_otlp_proto_common-1.25.0.tar.gz"
    sha256 "c93f4e30da4eee02bacd1e004eb82ce4da143a2f8e15b987a9f603e0a85407d3"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/72/d9/1c3c518853c27d323a46813d3e99d601959ca2c6963d5217fe2110f0d579/opentelemetry_exporter_otlp_proto_http-1.25.0.tar.gz"
    sha256 "9f8723859e37c75183ea7afa73a3542f01d0fd274a5b97487ea24cb683d7d684"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/0f/20/0a5d980843e048e9516443a91c63a559b40e5d50a730e73e72a5bde727fd/opentelemetry_instrumentation-0.46b0.tar.gz"
    sha256 "974e0888fb2a1e01c38fbacc9483d024bb1132aad92d6d24e2e5543887a7adda"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https://files.pythonhosted.org/packages/f6/28/5b5e9fb74639e47f026a3fd6550bba965ca18b316a8178907540e711855c/opentelemetry_instrumentation_requests-0.46b0.tar.gz"
    sha256 "ef0ad63bfd0d52631daaf7d687e763dbd89b465f5cb052f12a4e67e5e3d181e4"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/c9/3c/28c9ce40eb8ab287471af81659089ca98ef4f7ce289669e23b19c29f24a8/opentelemetry_proto-1.25.0.tar.gz"
    sha256 "35b6ef9dc4a9f7853ecc5006738ad40443701e52c26099e197895cbda8b815a3"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/05/3c/77076b77f1d73141adc119f62370ec9456ef314ba0b4e7072e3775c36ef7/opentelemetry_sdk-1.25.0.tar.gz"
    sha256 "ce7fc319c57707ef5bf8b74fb9f8ebdb8bfafbe11898410e0d2a761d08a98ec7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/4e/ea/a4a5277247b3d2ed2e23a58b0d509c2eafa4ebb56038ba5b23c0f9ea6242/opentelemetry_semantic_conventions-0.46b0.tar.gz"
    sha256 "fbc982ecbb6a6e90869b15c1673be90bd18c8a56ff1cffc0864e38e2edffaefa"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/f0/91/45bf243850463b2c83000ca129442255eaef7c446bd0f59a2ab54b15abff/opentelemetry_util_http-0.46b0.tar.gz"
    sha256 "03b6e222642f9c7eae58d9132343e045b50aca9761fcb53709bd2b663571fdf6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/1e/ce/c2bb58d00cb12d19dea28d5a98d05a14350197a3d03eba60be9bae708bac/peewee-3.18.1.tar.gz"
    sha256 "a76a694b3b3012ce22f00d51fd83e55bf80b595275a90ed62cd36eb45496cf1d"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/df/01/34c8d2b6354906d728703cb9d546a0e534de479e25f1b581e4094c4a85cc/protobuf-4.25.8.tar.gz"
    sha256 "6135cf8affe1fc6f76cced2641e4ea8d3e59518d1f24ae41ba97bcad82d397cd"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e1/0a/929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8/requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/1d/d6/9773d48804d085962c4f522db96f6a9ea9bd2e0480b3959a929176d92f01/rich-13.5.3.tar.gz"
    sha256 "87b43e0543149efa1253f485cd845bb7ee54df16c9617b8a893650ab84b4acb6"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/a5/aa/4456d84bbb54adc6a916fb10c9b374f78ac840337644e4a5eda229c81275/rpds_py-0.26.0.tar.gz"
    sha256 "20dae58a859b0906f0685642e591056f1e787f3a8b39c8e8749a45dc7d26bdb0"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/35/b9/de2a5c0144d7d75a57ff355c0c24054f965b2dc3036456ae03a51ea6264b/tomli-2.0.2.tar.gz"
    sha256 "d46d457a85337051c36524bc5349dd91b1877838e2979ac5ced3e710ed8a60ed"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/d1/bc/51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5/typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/ea/c4/55e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968/wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    # Ensure dynamic linkage to our libraries
    inreplace "src/main/flags.sh" do |s|
      s.gsub!("$(brew --prefix libev)/lib/libev.a", Formula["libev"].opt_lib/shared_library("libev"))
      s.gsub!("$(brew --prefix zstd)/lib/libzstd.a", Formula["zstd"].opt_lib/shared_library("libzstd"))
      s.gsub!("$(pkg-config gmp --variable libdir)/libgmp.a", Formula["gmp"].opt_lib/shared_library("libgmp"))
      s.gsub!(
        "$(pkg-config tree-sitter --variable libdir)/libtree-sitter.a",
        Formula["tree-sitter"].opt_lib/shared_library("libtree-sitter"),
      )
      s.gsub!(
        "$(pkg-config libpcre --variable libdir)/libpcre.a",
        Formula["pcre"].opt_lib/shared_library("libpcre"),
      )
      s.gsub!(
        "$(pkg-config libpcre2-8 --variable libdir)/libpcre2-8.a",
        Formula["pcre2"].opt_lib/shared_library("libpcre2-8"),
      )
    end

    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      # `--no-depexts` prevents opam from attempting to automatically search for
      # and install system dependencies using the os-native package manager.
      # On Linux, this leads to confusing and inaccurate `Missing dependency`
      # errors due to querying `apt`. See:
      #   https://github.com/Homebrew/homebrew-core/pull/82693
      #   https://github.com/Homebrew/homebrew-core/pull/176636
      #   https://github.com/ocaml/opam/pull/4548
      ENV["OPAMNODEPEXTS"] = ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}/lib"
      # Opam's solver times out when it is set to the default of 60.0
      # See: https://github.com/Homebrew/homebrew-core/pull/191306
      ENV["OPAMSOLVERTIMEOUT"] = "1200"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.5.3.0" }

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"
      system "opam", "install", "-y", "--deps-only", "./libs/ocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "./"
      cd "./libs/ocaml-tree-sitter-core" do
        system "./configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.13")
    venv.pip_install resources.reject { |r| r.name == "glom" }

    # Replace `imp` usage: https://github.com/mahmoud/glom/commit/1f883f0db898d6b15fcc0f293225dcccc16b2a57
    # TODO: remove with glom>=23.4.0
    resource("glom").stage do |r|
      inreplace "setup.py", "import imp", ""
      inreplace "setup.py", "_version_mod = imp.load_source('_version', _version_mod_path)", ""
      inreplace "setup.py", "_version_mod.__version__", "'#{r.version}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath/"cli"

    generate_completions_from_executable(bin/"semgrep", "--legacy",
                                         shells:                 [:bash, :fish, :zsh],
                                         shell_parameter_format: :click)
  end

  test do
    system bin/"semgrep", "--help"
    (testpath/"script.py").write <<~PYTHON
      def silly_eq(a, b):
        return a + b == a + b
    PYTHON

    output = shell_output("#{bin}/semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath/"script.ts").write <<~TYPESCRIPT
      function test_equal() {
        a = 1;
        b = 2;
        //ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    TYPESCRIPT

    output = shell_output("#{bin}/semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end
