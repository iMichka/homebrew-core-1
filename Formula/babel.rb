require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.7.7.tgz"
  sha256 "15f2266ab54addd1c18c88225cbb24d298720f46988bcb8a6ca2a46abdc89fa3"

  bottle do
    sha256 "8cd0b43d3e79e7b59f65c554479ef228496da922ac8fa680421f6fe93f8bbc8d" => :catalina
    sha256 "455e27486c4f3597b266e6ffe9570b71ed2a6340db130b2b9d2645af03ac36f4" => :mojave
    sha256 "0d56fd0058fb33902ef980897293eacfe7e79d78f00c1758a042d2615242b542" => :high_sierra
    sha256 "d683508c95bd0dd34cc48fd63e49cbcb8dfb12795e8d38462f52c9c8c4dd0298" => :x86_64_linux
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.7.7.tgz"
    sha256 "d28508eba145aae23b9e0732b8a473a08ba3489a7524a0c35281c2936c5ed1e0"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    # declare babel-core as a bundledDependency of babel-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["@babel/core"] = version
    pkg_json["bundledDependencies"] = ["@babel/core"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end
