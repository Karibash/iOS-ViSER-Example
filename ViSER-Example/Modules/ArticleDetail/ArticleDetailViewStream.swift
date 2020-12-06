//
//  ArticleDetailViewStream.swift
//  ViSER-Example
//
//  Created by Karibash on 2020/12/06.
//

import RxCocoa
import RxSwift
import Unio

protocol ArticleDetailViewStreamType: AnyObject {
    var input: InputWrapper<ArticleDetailViewDependency.Input> { get }
    var output: OutputWrapper<ArticleDetailViewDependency.Output> { get }
}

final class ArticleDetailViewStream: UnioStream<ArticleDetailViewStream>, ArticleDetailViewStreamType {

    convenience init(extra: Extra) {
        self.init(input: Input(),
                  state: State(),
                  extra: extra)
    }

}

extension ArticleDetailViewStream {

    typealias Input = ArticleDetailViewDependency.Input
    typealias Output = ArticleDetailViewDependency.Output
    typealias Extra = ArticleDetailViewDependency.Extra

    static func bind(from dependency: Dependency<Input, NoState, Extra>, disposeBag: DisposeBag) -> Output {
        // MARK: Extra
        let article = dependency.extra.article

        return Output(
            title: Driver.of(article.title),
            url: Driver.of(URLRequest(url: URL(string: "https://www.google.com")!))
        )
    }

}