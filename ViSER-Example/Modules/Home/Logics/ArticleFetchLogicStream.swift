//
//  ArticleFetchLogicStream.swift
//  ViSER-Example
//
//  Created by Karibash on 2020/12/04.
//

import RxCocoa
import RxSwift
import Unio

protocol ArticleFetchLogicStreamType: AnyObject {
    var input: InputWrapper<ArticleFetchLogicDependency.Input> { get }
    var output: OutputWrapper<ArticleFetchLogicDependency.Output> { get }
}

final class ArticleFetchLogicStream: UnioStream<ArticleFetchLogicStream>, ArticleFetchLogicStreamType {

    convenience init(extra: Extra) {
        self.init(input: Input(),
                  state: State(),
                  extra: extra)
    }

}

extension ArticleFetchLogicStream {

    typealias Input = ArticleFetchLogicDependency.Input
    typealias Output = ArticleFetchLogicDependency.Output
    typealias State = ArticleFetchLogicDependency.State
    typealias Extra = ArticleFetchLogicDependency.Extra

    static func bind(from dependency: Dependency<Input, State, Extra>, disposeBag: DisposeBag) -> Output {
        // MARK: Input
        let fetchTrigger = dependency.inputObservables.fetchTrigger
        // MARK: State
        let articles = dependency.state.articles
        let page = dependency.state.page
        // MARK: Extra
        let articleRepository = dependency.extra.articleRepository

        fetchTrigger
            .flatMapLatest { articles }
            .flatMapFirst { articles in
                articleRepository
                    .paginate(page: page.value)
                    .map { fetchedArticles in articles + fetchedArticles }
                    .map { fetchedArticles in fetchedArticles.sorted(by: >) }
            }
            .do(onNext: { _ in page.accept(page.value + 1) })
            .bind(to: articles)
            .disposed(by: disposeBag)

        return Output(
            articles: articles.asObservable()
        )
    }
}
