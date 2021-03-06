class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.13.tar.gz"
  sha256 "90d9a65ef6cbb9e61197a54c292105981b5a3528268f76eb61067112332f4538"
  revision 1
  head "https://github.com/dreibh/bibtexconv.git"

  bottle do
    cellar :any
    sha256 "6734b6f8a657a1477aae12078d7bf6acebb2710124fbe470ce070b4fb4c10c4f" => :catalina
    sha256 "fca5b1120067ca86d540ebd3bc5b71b4e8567bb759962242e4a68369ff6de4e1" => :mojave
    sha256 "3813b8a7920ee92df6e8c24300f330c197a08f58d279062595783dcdf0c98cfd" => :high_sierra
    sha256 "d4e1cdb0c6472cb890fe8c6cbe8aa55fc6915e7d479b1b293cad1d777891437d" => :sierra
    sha256 "3d157517624f4990c9c1df85b970b55bbe58d14874928925fa6c893d8cebb314" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  unless OS.mac?
    depends_on "bison" => :build
    depends_on "flex" => :build
    depends_on "curl"
  end

  def install
    dylib = OS.mac? ? "dylib" : "so"
    system "cmake", *std_cmake_args,
	            "-DCRYPTO_LIBRARY=#{Formula["openssl@1.1"].opt_lib}/libcrypto.#{dylib}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
